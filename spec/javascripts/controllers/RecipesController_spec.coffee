describe "RecipesController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null
  httpBackend  = null

  setupController =(keywords,results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller)->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.keywords = keywords

      if results
        request = new RegExp("\/recipes.*keywords=#{keywords}")
        httpBackend.expectGET(request).respond(results)

      ctrl        = $controller('RecipesController',
        $scope: scope
        $location: location)
    )

  beforeEach(module("receta"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  # Check controller initialization
  describe 'controller initialization', ->

    # Check that on initialization with no keywords, recipes is empty
    describe 'when no keywords present', ->
      beforeEach(setupController())

      it 'defaults to no recipes', ->
        expect(scope.recipes).toEqualData([])

    # Check that on initialization with keywords, we call the backend and populate recipes with the results
    describe 'with keywords', ->
      keywords = 'foo'
      recipes = [
        {
          id: 2
          name: 'Baked Potatoes'
        },
        {
          id: 4
          name: 'Potatoes Au Gratin'
        }
      ]
      beforeEach ->
        setupController(keywords,recipes)
        httpBackend.flush()

      it 'calls the back-end', ->
        expect(scope.recipes).toEqualData(recipes)

  # Verify that clicking search() redirects us back to ourselves with the correct query string
  describe 'search()', ->
    beforeEach ->
      setupController()

    it 'redirects to itself with a keyword param', ->
      keywords = 'foo'
      scope.search(keywords)
      expect(location.path()).toBe("/")
      expect(location.search()).toEqualData({keywords: keywords})
