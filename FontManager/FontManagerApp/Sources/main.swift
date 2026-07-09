import Foundation

do {

    // Initialize the app, validating the font directory
    let directory = try FontDirectory()
    
    // Write fonts for `Info.plist` plist
    try FontListMapping(directory: directory).write()
    
    // Write preferred font plist
    try PreferredFontMapping(directory: directory).write()
    
    // Success!
    Console.write("[SUCCESS] plist files written successfully")

} catch {

    // Failure!
    Console.write("[FAILURE] An error occured: \(error)")
}
