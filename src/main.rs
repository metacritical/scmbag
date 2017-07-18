use std::env;
use std::process::Command;

fn main(){
    let args: Vec<String> = env::args().collect();
    println!("{:?}", args[1]);

    let git_command = Command::new("git");
    .arg("status")
        


}
