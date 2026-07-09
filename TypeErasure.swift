import Foundation

// MARK: - Food

protocol Food: CustomStringConvertible {
  var price: Decimal { get }
}

extension Food {
  var description: String {
    "\(Self.self) \(price)"
  }
}

struct Apple: Food {
  var price: Decimal { 0.5 }
}

struct Orange: Food {
  var price: Decimal { 1 }
}

struct Banana: Food {
  var price: Decimal { 0.25 }
}

let foods: [Food] = [Apple(), Orange(), Banana()]
print(foods) // [Apple 0.5, Orange 1, Banana 0.25]

// MARK: - Job

protocol Job: CustomStringConvertible {
  associatedtype Title: CustomStringConvertible
  var title: Title { get }
}

extension Job {
  var description: String {
    "\(Self.self) \(title)"
  }
}

struct Engineer: Job {
  var title = "Engineer"
}

struct Teacher: Job {
  struct Course: CustomStringConvertible {
    var title: String
    var description: String { title }
  }

  var title = Course(title: "Mathematics")
}

let jobs: [any Job] = [Engineer(), Teacher()]
print(jobs) // [Engineer Engineer, Teacher Mathematics]

// MARK: - Erased Job

struct AnyJob: Job {
  var title: String

  init(job: some Job) {
    title = job.title.description
  }
}

let anyJobs: [AnyJob] = [
  AnyJob(job: Engineer()),
  AnyJob(job: Teacher())
]
print(anyJobs) // [AnyJob Engineer, AnyJob Mathematics]
