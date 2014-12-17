angular.module('app', ['ngRoute', 'angularMoment', 'ngAnimate'])
.config(function($routeProvider) {
  'use strict';

  $routeProvider
    .when('/', {
      controller: 'PicController',
      templateUrl: 'picweb-index.html'
    })
    .otherwise({
      redirectTo: '/'
    });
})

.controller('MainController', ['$scope', function($scope) {
  
}])
.controller('PicController', ['$scope', '$timeout', 'PicService', function($scope, $timeout, PicService) {
  $scope.test = "Apa";

  $scope.partitionedPictures = [];
  $scope.pictures = [];

  $scope.init = function() {

    PicService.loadPictures().then(function (result) {
      $scope.partitionedPictures = partition(result, 3);
      $scope.pictures = result;
    });
  }
  function partition(arr, size) {
    var newArr = [];
    for (var i=0; i<arr.length; i+=size) {
      newArr.push(arr.slice(i, i+size));
    }
  return newArr;
  }

}])
.service('PicService', function($http, $q) {
  return ({
    loadPictures: loadPictures
  });

  function loadPictures() {
    var request = $http({
      method: "GET",
      url: "/api/v1/pictures.json"
    });
    return (request.then(function(response) {
      return response.data;
    }, function(response) {

      if (!angular.isObject(response.data) || !response.data.message) {
        return($q.reject("An unknown error occurred.") );
      } 
      return($q.reject(response.data.message));

    }))
  }
});
