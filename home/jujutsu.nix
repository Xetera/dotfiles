{ gitName, gitEmail, ... }: {
  enable = true;
  settings = {
    user = {
      email = gitEmail;
      name = gitName;
    };
    colors = {
      commit_id = "green";
    };
  };
}
