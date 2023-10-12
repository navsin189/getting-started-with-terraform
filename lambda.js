export const handler = async (event) => {
    welcome()
}

function welcome(){
    let welcome_string = "Welcome to Lambda Fununction"
    console.log(welcome_string)
}