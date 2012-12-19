SDScaffoldKit
=======
**Scaffolding for CoreData Models**

UIKit can be tedious and repeative to build simple CRUD interfaces. SDScaffoldKit is a simple library that provides Create, Read, Update, and Delete views/viewcontrollers out-of-the-box. Just create your CoreData model, hand it your Entity's name and a field to sort by and BAM! You are ready to start creating and managing objects.

> SDScaffoldKit is named after Ruby on Rails scaffolding.http://guides.rubyonrails.org/getting_started.html#getting-up-and-running-quickly-with-scaffolding

SDScaffoldingKit is meant to save you time so you can focus on what matters, application logic. The library is still a little green behind the ears and I would love to see any issues or pull request you may have. Overall, this is a great way to get your project up and running then you can go from there.

> If you enjoy this project, I would encourage you to check out [Mattt Thompson's](http://www.github.com/mattt) series of open source libraries covering the mission-critical aspects of an iOS app's infrastructure. Be sure to check out its sister projects: [GroundControl](https://github.com/mattt/GroundControl), [SkyLab](https://github.com/mattt/SkyLab), [CargoBay](https://github.com/mattt/CargoBay), and [houston](https://github.com/mattt/houston).

## Getting Started

### Create Core Data Models

1. Add Core Data into your project
2. Create CoreData Model
3. Create SDScaffoldViewController instance with desginated initizer initWithEntityName:soryBy:context:andStyle:
4. Wrap SDScaffoldViewController instance in UINavigationController
5. Done!

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    SDScaffoldViewController *scaffoldViewController = [[SDScaffoldViewController alloc] initWithEntityName:@"User" sortBy:@"lastname" context:[self managedObjectContext]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scaffoldViewController];
  
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
```
## Contact

Steve Derico

- http://github.com/stevederico
- http://twitter.com/stevederico
- steve@deri.co

## License

SDScaffoldKit is available under the MIT license. See the LICENSE file for more info.
