# Unit tests for our lib functions
{ pkgs, lib, xrLibrary ? import ../../lib { inherit lib; } }:

let
  # Test utility function - returns success message or throws error
  runTest = name: expected: actual:
    if expected == actual 
    then { inherit name; success = true; }
    else throw ''
      Test '${name}' failed.
      Expected: ${builtins.toJSON expected}
      Got:      ${builtins.toJSON actual}
    '';

  # Run all tests and return results
  allTests = [
    (runTest "formatVersion" "v1.2.3" (xrLibrary.formatVersion "1.2.3"))
    
    (runTest "isSupportedSystem-x86_64" true (xrLibrary.isSupportedSystem "x86_64-linux"))
    
    (runTest "isSupportedSystem-darwin" false (xrLibrary.isSupportedSystem "x86_64-darwin"))
    
    (runTest "makeDesktopFile" ''
      [Desktop Entry]
      Name=Test App
      Comment=Test Comment
      Exec=/bin/test
      Icon=/path/to/icon.svg
      Terminal=false
      Type=Application
      Categories=Utility;
    '' (xrLibrary.makeDesktopFile {
      name = "Test App";
      comment = "Test Comment";
      exec = "/bin/test";
      icon = "/path/to/icon.svg";
    }))
  ];
  
  # Generate a report
  report = {
    testResults = allTests;
    summary = {
      total = builtins.length allTests;
      passed = builtins.length allTests;
    };
  };
in
pkgs.runCommand "lib-tests" { 
  nativeBuildInputs = [ pkgs.jq ];
  passthru = report;
} ''
  echo '${builtins.toJSON report}' | jq > $out
  echo "All ${toString report.summary.total} tests passed!"
''