#![deny(warnings)]

extern crate libc;

use std::env;
use std::process::Command;


#[link(name = "libgit2")]






fn main(){
    let args: Vec<String> = env::args().collect();
    println!("{:?}", args);

    let git_out = Command::new("git")
    .arg("status").output().unwrap_or_else(|e| {
        panic!("failed to execute process: {}", e)
    });

    if git_out.status.success(){
        let s = String::from_utf8_lossy(&git_out.stdout);
        println!("{}", s);
    }

}
