Modules:

FeedAbstract: To define protocols and the models which can be used across different modules

FeedContent: responsible for implementing the protocol and provide the data remotely or from some other place

FeedCoordinator: for navigation, but in this project its used as composing component as well
    Ideally, the composing module will only be aware of FeedContent

FeedListViewModel: is responsible for logical part, is unaware of FeedContent Module


Static library: can have only code, no resources like storyboard, nib, string file etc
To use resources with static library, a bundle can be created, but the easier option can be using staitic framework

Framework is also a bundle with code and resources

To change the settings of a framework from static to dynamic:
Build setting of framework -> type mach o 

To change the settings of ember, not embed or ember with sign:
Goto the target client -> General -> Library -> update the option

Static Library:
If no resources are there

Dynamic Library:
Only Apple is allowed to create dynamic libraries for iOS . You're not allowed to create these, as this will get your app rejected

Static Framework: The static library is always compiled and embedded in the executable
1. Embed with/without signin : If the archive is created with static library with embed, it will be creating 2 copies of the code. as the code is already there in the app executable, it will be only increasing the binary size
2. If the framework is already signed in then it can be embed without signin, where as if its not, it should be signed in
3. The best option to use static framework is without embedding.

Pros:
1. The launch time is fatser, as its already loaded in memory with app code
2. Static libraries are guaranteed to be present in the app and have correct version.
3. No need to keep an app up to date with library updates.
4. Better performance of library calls.
Cons:
1. The app has to compiled and released again in order to change anything
2. Inflated app size.
3. Must copy whole library even if using single function.
4. Launch time degrades because of bloated app executable.


Dynamic framework: The dynamic framework is never part of executable, its linked at the loading time or run time based on the option choosen by client
1. Not Embedded: If the framework is not embedded, it will crash the app, as its not part of the executable
2. Embed: The ideal way to use it is with embed 
Pros:
1. Faster startup time, as it is loaded on-demand during runtime.
2. Can benefit from library improvements without app re-compile. Especially useful with system libraries.
3. Takes less disk space, since it is shared between applications.
4. Loaded by pieces: no need to load whole library if using single function.
Cons:
1. Can potentially break the program if anything changes in the library.
2. Slower calls to library functions, as it is located outside application executable.


Open the Result folder, select file, show package content, Conclusions:
1. Static Embed -> Extra size of Client executable, Framework folder with source files
2. Static Not-Embed -> Extra size of Client executable, No framework folder
3. Dynamic Embed -> Lesses size of client executable, framework folder with source file and library executable
4. Dynamic Not-Embed -> Lesses size of client executable, no framework folder and no library code in executable
