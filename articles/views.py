from django.shortcuts import render

from articles.models import Article


def articles_list(request):
    template = 'articles/index.html'
    articles = Article.objects.order_by('-published_at')
    context = {
        'object_list': articles
    }

    return render(request, template, context)
