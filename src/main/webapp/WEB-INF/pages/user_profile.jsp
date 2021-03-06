<%--
  Created by IntelliJ IDEA.
  User: Dmitrij
  Date: 12.10.2015
  Time: 3:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>${user.userName} places</title>

    <link href="<c:url value="/static/css/bootstrap.css"/>" rel="stylesheet"/>
    <link href="<c:url value="/static/css/pages/user-place-list.css"/>" rel="stylesheet"/>
    <link href="<c:url value="/static/css/font-awesome.css"/>" rel="stylesheet"/>
    <!-- Bootstrap -->
    <link rel="stylesheet" href="<c:url value="/static/dist/themes/fontawesome-stars.css"/>">

    <script src="<c:url value="/static/js/jquery.min.js"/>"></script>
    <script src="<c:url value="/static/dist/jquery.barrating.min.js"/>"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="<c:url value="/static/js/bootstrap.js"/>"></script>
    <script src="<c:url value="/static/js/salvattore.min.js"/>"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>

    <![endif]-->

    <style>
        .panel-heading {
            padding: 4px;
        }

        table tr:first-child td {
            border-top: 0;
        }

        table tr:last-child td {
            border-bottom: 1px;
        }

        .place-link:hover {
            color: white;
        }

        .place-link {
            color: #dddddd;
        }

        .table {
            margin-bottom: 0;
        }

        .btn-toggle {
            float: right;
        }

        .menu-name-v {
            padding-bottom: 0;
            vertical-align: top;
            padding-top: 0;
            height: 1px;
        }

        .menu-name {
            float: right;
            margin-bottom: 0;
        }

        .place-img-w {
            width: 240px;
            padding: 4px 8px 8px 4px;
        }

        .menu-conf-toggle {
            border-left: 0;
            border-radius: 0 4px 4px 0px;
        }

        .panel-body table {
            border-bottom: 1px solid #ddd;
        }

        .panel-body table:last-child {
            border-bottom: 0;
        }

        .panel-default > .panel-heading {
            background-color: white;
        }

        .place-btn {
            background-color: transparent;
            color: white;
        }

        .place-btn:hover {
            background-color: rgba(227, 229, 234, 0.2);
            color: #ddd;
        }
    </style>
</head>
<body>

<div class="navbar navbar-inverse navbar-static-top">
    <div class="container">
        <div class="navbar-header">
            <a href="#" class="navbar-brand">MyPlaceToGo</a>
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#responcive-menu">
                <span class="sr-only">Відкрити меню</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
        </div>
        <div class="collapse navbar-collapse" id="responcive-menu">
            <ul class="nav navbar-nav">
                <li><a href="#">На головну</a></li>

                <security:authorize access="isAuthenticated()">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Мій профіль<b class="caret"></b></a>
                        <ul id="user-menu-dropdown" class="list-group dropdown-menu">
                            <li id="menu-item-my-page" class="list-group-item"><a href="#"><i
                                    class="fa fa-user fa-fm"></i>Моя
                                сторінка</a></li>
                            <li class="list-group-item"><a href="#"><i class="fa fa-bullhorn fa-fm"></i>Мої
                                замовлення</a>
                            </li>
                            <li class="list-group-item"><a href="#"><i class="fa fa-calendar-check-o fa-fm"></i>Мої
                                події</a></li>
                            <li class="list-group-item"><a href="#"><i class="fa fa-cutlery fa-fm"></i>Мої заклади</a>
                            </li>
                            <li class="list-group-item"><a href="#"><i class="fa fa-power-off fa-fm"></i>Вийти</a></li>
                        </ul>
                    </li>
                    <security:authorize access="hasRole('ROLE_USER')">
                    <li>
                        <a href="/newplace">Приєднатись</a>
                    </li>
                </security:authorize>
                </security:authorize>

                <security:authorize access="isAnonymous()">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Увійти<b class="caret"></b></a>
                        <ul id="enter-form" class="dropdown-menu navbar-form">
                            <li>
                                <span id="authorization-span"></span>

                                <form action="/login" id="authorization-form" method="POST">

                                    <div class="input-group" id="authorization-email">
                                        <span class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></span>
                                        <input class="form-control" type="text" name="j_username" placeholder="E-mail">
                                    </div>
                                    <br>

                                    <div class="input-group" id="authorization-password">
                                        <span class="input-group-addon"><i class="fa fa-key fa-fw"></i></span>
                                        <input class="form-control" type="password" name="j_password"
                                               placeholder="Password">
                                    </div>

                                    <div id="authorization-divider" class="divider"></div>

                                    <div id="authorization-group" class="btn-group">

                                        <button type="submit" class="btn btn-default authentication-button">
                                            <i class="fa fa-circle-thin"><span style="padding-right: 4px"></span>Увійти</i>
                                        </button>

                                        <a href="#" class="btn btn-default authentication-button">
                                            <i class="fa fa-user-plus"><span
                                                    style="padding-right: 4px"></span>Реестрація</i>
                                        </a>
                                    </div>
                                </form>
                            </li>
                        </ul>
                    </li>
                </security:authorize>
            </ul>

            <form action="" id="search-form" class="navbar-form navbar-right">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-search fa-fw"></i></span>
                    <input class="form-control" type="text" placeholder="search stuff">
                </div>
            </form>


        </div>
    </div>
</div>


<div class="container">
    <div class="row">
        <div class="col col-md-2 hidden-sm hidden-xs">
            <ul class="list-group" id="user-controls">

                <li class="list-group-item">
                    <img id="user-photo" class="img-responsive"
                         <c:if test="${user.photos.size()==0}">src="http://placehold.it/100x100"</c:if>
                            <c:if test="${user.photos ne null}"> src="user/${user.id}/photo/main"</c:if>
                            />
                </li>
                <li class="list-group-item">
                    <a href="#"><i class="fa fa-user fa-fm"></i><c:out value="${user.userName}"/></a>
                </li>
                <li class="list-group-item"><a href="/user/orders">
                    <i class="fa fa-bullhorn fa-fm"></i>Мої замовлення</a>
                </li>
                <li class="list-group-item"><a href="/user/${user.id}/events">
                    <i class="fa fa-calendar-check-o fa-fm"></i>Мої події</a></li>
                <li class="list-group-item"><a href="/user/places">
                    <i class="fa fa-cutlery fa-fm"></i>Мої заклади</a>
                </li>

                <li class="list-group-item">
                    <a href="#"><i class="glyphicon glyphicon-cog fa-fm"></i>Налаштування</a>
                </li>

                <li class="list-group-item">
                    <a href="/logout"><i class="fa fa-power-off fa-fm"></i>Вийти</a>
                </li>
            </ul>
        </div>
        <!--   <table class="table">
                                                <tr>
                                                    <td class="place-img-w" rowspan="3">
                                                        <img class="place-img" src="/photo/place/${place.id}/small"
                                                             width="240" onerror="http://placehold.it/160x90"/>
                                                    </td>

                                                    <td style="padding-bottom: 1px;vertical-align: bottom;">
                                                        <h3 style="float: right;margin-bottom: 0;">${place.placeName}</h3>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="padding: 0;">
                                                        <h5 style="margin-top: 5px" class="place-name-exp">
                                                        <span class="badge"><a href="/place/${place.id}}"
                                                                               class="place-link">${place.placeOwner.name}</a></span>
                                                            <i class="fa fa-cultery"></i>
                                                        </h5>
                                                    </td>
                                                <tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <div class="btn-group btn-place-dropdown btn-right btn-toggle">
                                                            <a class="btn btn-primary" data-toggle="collapse"
                                                               href="#place-${i.getCount()}">Переглянути замовлення</a>
                                                            <a class="btn btn-primary">
                                                                <span class="badge">${places.userUserOrderses.size()}</span>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>-->

        <div class="col col-xs-12 col-md-12 col-lg-10">
            <div class="container">
                <div class="row masonry" data-columns>
                    <jsp:useBean id="ordersMap" scope="request"
                                 type="java.util.List<com.example.pojo.dto.UserPlaceOrdersDTO>"/>
                    <c:forEach items="${ordersMap}" var="places" varStatus="i">
                        <c:set var="place" value="${places.place}"/>
                        <div>
                            <div class="panel panel-default" style="border: 0;box-shadow: 2px 3px 8px;"
                                 id="places-list">
                                <div class="panel-groupe">
                                    <div class="panel panel-default place-panel">
                                        <div style="text-align: center; padding:0" class="panel-heading">

                                            <img class="place-img" src="/photo/place/${place.id}/small"
                                                 width="100%" height="100%" onerror="http://placehold.it/160x90"/>
                                            <a class="btn btn-default place-btn" href="/place/${place.id}"
                                               style="margin-top:-100px">${place.placeName}</a>
                                            <br/>
                                            <a class="btn" data-toggle="collapse" style="margin-top:-25px"
                                               href="#place-${i.getCount()}">Переглянути замовлення</a>


                                        </div>
                                    </div>
                                    <div class="collapse panel-collapse" id="place-${i.getCount()}">
                                        <div class="panel-body">
                                            <c:forEach items="${places.userUserOrderses}" var="userOrders"
                                                       varStatus="o">
                                                <table class="table" id="user-order-${userOrders.id}">
                                                    <tr>
                                                        <td width="150px" rowspan="3">
                                                            <img class="event-image"
                                                                 src="<c:url value="/photo/menu/${userOrders.menu.id}/small"/>"
                                                                 width="150px" onerror="http://placehold.it/100x100"/>
                                                        </td>
                                                        <td style="padding-bottom: 0;vertical-align: top;padding-top: 0;height: 1px;">
                                                            <h3 class="menu-name">${userOrders.menu.menuName}</h3>
                                                        </td>
                                                        <!--
                                                        <td style="padding-bottom: 0; vertical-align: bottom;">
                                                            <p style="margin-bottom: 0; text-align: center">
                                                            <span class="menu_timer" style="color: #ddd; font-size: 150%; font-weight: bold;">01:10:00</span>
                                                                </p>
                                                        </td>-->
                                                    </tr>
                                                    <tr>
                                                        <td style="border-top:0" colspan="3">
                                                        <span class="badge" style="float: right;"><i
                                                                class="fa fa-tags"></i> ${userOrders.menu.menuPrice}</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <div class="btn-group dropup" style="float: right;">
                                                                <a style="cursor:pointer;" data-toggle="modal"
                                                                   data-target="#new-comment"
                                                                   data-id="${userOrders.id}"
                                                                   class="btn btn-default">
                                                                    <i class="fa fa-hand-peace-o"></i>Підтвердити
                                                                </a>
                                                                <a class="btn btn-default menu-conf-toggle"
                                                                   data-toggle="dropdown">
                                                                    <span class="caret"></span> </a>
                                                                <ul class="dropdown-menu">
                                                                    <li>
                                                                        <a>
                                                                            <i class="fa fa-cog"></i>Змінити
                                                                        </a>
                                                                    </li>
                                                                    <li>
                                                                        <a>
                                                                            <i class="fa fa-close"></i>Відмінити
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </c:forEach>
                                        </div>
                                    </div>

                                </div>
                            </div>


                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="new-comment" class="modal fade">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button style="margin-top: -9px;" type="button" class="close" data-dismiss="modal"
                        aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
            </div>
            <div style="text-align: center" class="modal-body">
                <div>
                    <textarea class="form-control"
                              style="position:relative; resize:vertical;width: 200px; margin-left: -100px; left:50%"
                              id="comment" rows="5"></textarea>
                </div>
                <select id="example">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
            </div>
        </div>
    </div>
</div>
<script>
    var id;

    $(document).ready(function () {
        var ratingB = $('#example');
        ratingB.barrating({
            theme: 'fontawesome-stars',
            onSelect: function (value, text, event) {
                if (typeof(event) !== 'undefined') {
                    $.ajax({
                        url: "/menu/" + id + "/comment",
                        data: {
                            comment: $("#comment").val(),
                            rating: value
                        },
                        method: "POST"
                    }).success(function () {
                        $('#new-comment').modal('hide');
                        var order = $("#user-order-" + id);
                        order.hide("slow", function () {
                            order.remove()
                        })
                    })
                }
            }
        });


        $('#new-comment').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            id = button.data('id');
        });
        $(".star").click(
                $(".comment-form").submit()
        );
    });
</script>

<script src="/static/js/salvattore.min.js"></script>
</body>
</html>
