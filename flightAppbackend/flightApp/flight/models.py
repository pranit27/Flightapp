from django.db import models

# Create your models here.

class Flight(models.Model):
    flight_number = models.CharField(max_length=20)
    departure_city = models.CharField(max_length=30)
    arrival_city = models.CharField(max_length=30)
    departure_time = models.DateTimeField()
    arrival_time = models.DateTimeField()

    def __str__(self):
        return f'{self.flight_number} - {self.departure_city} - {self.arrival_city}'
