from django.shortcuts import render
from .serializers import FlightSerializer
from .models import Flight
from rest_framework import viewsets
from django.views.generic.edit import UpdateView, CreateView
from rest_framework import generics
from drf_yasg.utils import swagger_auto_schema
from rest_framework.response import Response
from rest_framework import status
from django.http import HttpResponse
from django.utils.dateparse import parse_datetime
# Create your views here.

class FlightView(generics.GenericAPIView):
    queryset = Flight.objects.all()
    serializer_class = FlightSerializer

class FlightCreateView(generics.GenericAPIView):
    serializer_class = FlightSerializer

    swagger_auto_schema(responses={201: {}})

    def post(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({}, status=status.HTTP_200_OK)

class FlightUpdateView(generics.GenericAPIView):
    serializer_class = FlightSerializer

    swagger_auto_schema(responses={201: {}})

    def put(self, request,id):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({}, status=status.HTTP_200_OK)

class FlightPlanView(generics.GenericAPIView):
    serializer_class = FlightSerializer
    
    swagger_auto_schema(responses={201: {}})
    
    def post(self, request):
        _departure_city = request.data['departure_city']
        _arrival_city = request.data['arrival_city']
        _departure_time = parse_datetime((request.data['departure_time']))
        queryset = Flight.objects.filter(departure_city = _departure_city,arrival_city=_arrival_city,departure_time__gte = _departure_time).order_by('departure_time')
        # queryset = Flight.objects.all()
        serializer = FlightSerializer(queryset,many=True)
        print(serializer.data)
        return Response(serializer.data, status=status.HTTP_200_OK)
    def options(self, request):
        response = HttpResponse()
        response['allow'] = ','.join(''.join(elems) for elems in self.allowed_methods)
        return response
    
