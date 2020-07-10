MAINTAINER Niv Sardi <x@btn.sh>
FROM jupyter/datascience-notebook
RUN pip install ipywidgets
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN perl -pi -e "s/.*c\.NotebookApp\.token.*/c.NotebookApp.token = ''/" /home/jovyan/.jupyter/jupyter_notebook_config.py 

WORKDIR /home/jovyan/work
ENV JUPYTER_ENABLE_LAB=yes


