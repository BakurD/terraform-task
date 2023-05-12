import os
import json

def post_gen_project(context, **kwargs):
    domain_list = context["cookiecutter"]["domain_list"]
    project_dir = context["cookiecutter"]["project_name"]
