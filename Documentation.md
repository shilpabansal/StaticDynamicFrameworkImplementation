When developing the iOS apps you rarely implement everything from the ground-up, because operating system as well as open source community offers large amount of functionality ready-to-use. Applications tend to grow and so does their source code. Hence, structuring the codebase into manageable components is a vital part of every app. This is done for various reasons: reducing code complexity, maintaining and reusing existing parts or even optimising the app itself. In iOS we have various ways of packaging and delivering such components. All the options can leave a developer wondering what the differences between the various methods are.

A module is a single unit of code distribution, a framework or application that is built and shipped as a single unit and that can be imported by another module with swift’s import keyword.

Libraries:
They are the files that define pieces of code and data that are not a part of your Xcode target

Bundle: 
A bundle is a file directory with subdirectories inside. On iOS, bundles serve to conveniently ship related files together in one package – for instance, images, nibs, or compiled code. The system treats it as one file and you can access bundle resources without knowing its internal structure.
The library may also have additional resources: headers, localization files, images, documentation and examples of usage. We can bundle all of this together in one bundle – and the name of this is framework.

Types of Bundles
Although all bundles support the same basic features, there are variations in the way you define and create bundles that define their intended usage:
1. Application - An application bundle manages the code and resources associated with a launch-able process. 
 For eg iOS application bundle contains info.plist, executable, resources and other supported files. 
2. Frameworks - A framework bundle manages a dynamic shared library and its associated resources, such as header files. An application can link against one or more frameworks to take advantage of the code they contain.
3. Plug-Ins - macOS supports plug-ins for many system features.


Framework:
It is a package that can contain resources such as dynamic libraries, strings, headers, images, storyboards etc.
Frameworks are also bundles ending with .framework extension. They can be accessed by NSBundle / Bundle class from code and, unlike most bundle files, can be browsed in the file system that makes it easier for developers to inspect its contents. Frameworks have versioned bundle format which allows to store multiple copies of code and headers to support older program version


Static library - a unit of code linked at compile time, which does not change. (Can only contain code). The code that the app uses is copied to the generated executable file by a static linker during compilation time.  
However, iOS static libraries are not allowed to contain images/assets (only code). You can get around this challenge by using a media bundle though.

Dynamic library - a unit of code and/or assets linked at runtime that may change. They are different from static libraries in the sense that they are linked with the app’s executable at runtime, but not copied into it. As a result, the executable is smaller and, because the code is loaded only when it is needed, the startup time is typically faster. They are usually shared between applications, therefore the system needs to store only one copy of the library and let different processes access it. As a result, invoking code and data from dynamic libraries happens slower than from the static ones.

Dynamic libraries outside of a framework bundle, which typically have the file extension .dylib, are not supported on iOS, watchOS, or tvOS, except for the system Swift libraries provided by Xcode. You're not allowed to create these, as this will get your app rejected. Only Apple is allowed to create dynamic libraries for iOS . System iOS and macOS libraries are dynamic. This means that your app will receive improvements from Apple’s updates without new build submission. This also may lead to issues with interoperability. That’s why it is always a good idea to test the app on the new OS version before it becomes released.

Text Based .dylib Stubs
When we link system libraries, such as UIKit or Foundation, we don’t want to copy their entirety into the app, because it would be too large. Linker is also strict about this and does not accept shared .dylib libraries to be linked against, but only .tbd ones. So what are those?
Text-based .dylib stub, or .tbd, is a text file that contains the names of the methods without their bodies, declared in a dynamic library . It results in a significantly lower size of .tbd compared to a matching .dylib. Along with method names, it contains location of the corresponding .dylib, architecture, platform and some other metadata. 


Two important factors that determine the performance of apps are their launch times and their memory footprints. Reducing the size of an app’s executable file and minimising its use of memory once it’s launched make the app launch faster and use less memory once it’s launched. Using dynamic libraries instead of static libraries reduces the executable file size of an app. They also allow apps to delay loading libraries with special functionality only when they’re needed instead of at launch time. This feature contributes further to reduced launch times and efficient memory use.


When an app is launched, the app’s code—which includes the code of the static libraries it was linked with—is loaded into the app’s address space. Linking many static libraries into an app produces large app executable files. Below diagram shows the memory usage of an app that uses functionality implemented in static libraries. Applications with large executables suffer from slow launch times and large memory footprints. Also, when a static library is updated, its client apps don’t benefit from the improvements made to it. To gain access to the improved functionality, the app’s developer must link the app's object files with the new version of the library. And the apps users would have to replace their copy of the app with the latest version. Therefore, keeping an app up to date with the latest functionality provided by static libraries requires disruptive work by both developers and end users.

![StaticLibraryFlow](https://github.com/shilpabansal/StaticAndDynamicLibraries/blob/master/StaticLibraryFlow.png)

A better approach is for an app to load code into its address space when it’s actually needed, either at launch time or at runtime. The type of library that provides this flexibility is called dynamic library. Dynamic libraries are not statically linked into client apps; they don't become part of the executable file. Instead, dynamic libraries can be loaded (and linked) into an app either when the app is launched or as it runs.
Note: Dynamic libraries are also known as dynamic shared libraries, shared objects, or dynamically linked libraries.

Below digrams shows how implementing some functionality as dynamic libraries instead of as static libraries reduces the memory used by the app after launch.
![DynamicLibraryFlow](https://github.com/shilpabansal/StaticAndDynamicLibraries/blob/master/DynamicLibraryFlow.png)

Using dynamic libraries, programs can benefit from improvements to the libraries they use automatically because their link to the libraries is dynamic, not static. That is, the functionality of the client apps can be improved and extended without requiring app developers to recompile the apps. Apps written for OS X benefit from this feature because all system libraries in OS X are dynamic libraries. This is how apps that use Carbon or Cocoa technologies benefit from improvements to OS X.
Another benefit dynamic libraries offer is that they can be initialised when they are loaded and can perform clean-up tasks when the client app terminates normally. Static libraries don’t have this feature. 

One issue that developers must keep in mind when developing dynamic libraries is maintaining compatibility with client apps as a library is updated. Because a library can be updated without the knowledge of the client-app’s developer, the app must be able to use the new version of the library without changes to its code. To that end, the library’s API should not change. However, there are times when improvements require API changes. In that case, the previous version of the library must remain in the user’s computer for the client app to run properly. Dynamic Library Design Guidelines explores the subject of managing compatibility with client apps as a dynamic library evolves.

How Dynamic Libraries Are Used
When an app is launched, the OS X kernel loads the app’s code and data into the address space of a new process. The kernel also loads the dynamic loader ( /usr/lib/dyld ) into the process and passes control to it. The dynamic loader then loads the app’s dependent libraries. These are the dynamic libraries the app was linked with. The static linker records the filenames of each of the dependent libraries at the time the app is linked. This filename is known as the dynamic library’s install name. The dynamic loader uses the app’s dependent libraries’ install names to locate them in the file system. If the dynamic loader doesn’t find all the app’s dependent libraries at launch time or if any of the libraries is not compatible with the app, the launch process is aborted.

The dynamic loader—in addition to automatically loading dynamic libraries at launch time—loads dynamic libraries at runtime, at the app’s request. That is, if an app doesn't require that a dynamic library be loaded when it launches, developers can choose to not link the app’s object files with the dynamic library, and, instead, load the dynamic library only in the parts of the app that require it. Using dynamic libraries this way speeds up the launch process.





DYNAMIC AND STATIC FRAMEWORKS

Static frameworks contain a static library packaged with its resources. Dynamic frameworks contain the static/dynamic library with its resources. In addition to that, dynamic frameworks may conveniently include different versions of the same dynamic library in the same framework.

Just like a dynamic shared library, frameworks provide a way to factor out commonly used code into a central location that can be shared by multiple applications. Only one copy of a framework’s code and resources reside in-memory at any given time, regardless of how many processes are using those resources. Applications that link against the framework then share the memory containing the framework. This behavior reduces the memory footprint of the system and helps improve performance.

Note: Only the code and read-only resources of a framework are shared. If a framework defines writable variables, each application gets its own copy of those variables to prevent it from affecting other applications.



