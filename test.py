import base64
from github import Github
from github import InputGitTreeElement
import os


def push_file(file_name, filepath):
    g = Github("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")
    repo = g.get_user().get_repo('cuck-test') 
    file_list = [
        filepath
    ]
    file_names = [
        file_name
    ]
    commit_message = 'python commit'
    master_ref = repo.get_git_ref('heads/main')
    master_sha = master_ref.object.sha
    base_tree = repo.get_git_tree(master_sha)

    element_list = list()
    for i, entry in enumerate(file_list):
        with open(entry) as input_file:
            data = input_file.read()
        if entry.endswith('.png'): # images must be encoded
            data = base64.b64encode(data)
        element = InputGitTreeElement(file_names[i], '100644', 'blob', data)
        element_list.append(element)

    tree = repo.create_git_tree(element_list, base_tree)
    parent = repo.get_git_commit(master_sha)
    commit = repo.create_git_commit(commit_message, tree, [parent])
    master_ref.edit(commit.sha)

push_file("test.py", f"{os.getcwd()}/test.py")