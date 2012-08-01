class Apartment
  constructor: ({@url, @title, published, @beds, @price, @latitude, @longitude}) ->
    @published = new Date published

  daysSincePosted: ->
    Math.floor (new Date() - @published) / (1000*60*60*24)

window.Apartment = Apartment
