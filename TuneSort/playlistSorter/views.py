from django.shortcuts import render
from django.http import HttpResponse
from datetime import datetime
# Create your views here.
def welcome(request):
    
    return render(request, 'playlistSorter/welcome.html', {'today': datetime.today()})