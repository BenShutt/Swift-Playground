# Coordinator

A simple UIKit coordinator architecture proof of concept.

## References

[Hacking With Swift](https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps) article.
The article suggests using coordinators for the following reasons:  

> - No view controllers know what comes next in the chain or how to configure it.
> - Any view controller can trigger your purchase flow without knowing how it’s done or repeating code.
> - You can add centralized code to handle iPads and other layout variations, or to do A/B testing.
> - But most importantly, you get true view controller isolation: each view controller is responsible only for itself. 
