import os
import json

def pre_gen_project(context, **kwargs):
    domain_list_file = context["cookiecutter"]["domain_list_file"]
    with open(domain_list_file, "r") as file:
        domain_list = file.read().splitlines()
    context["cookiecutter"]["domain_list"] = domain_list
