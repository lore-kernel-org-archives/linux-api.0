From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 06/22] media: Media Controller non-locking
 __media_entity_pipeline_start/stop()
Date: Thu, 4 Feb 2016 07:18:03 -0200
Message-ID: <20160204071803.29d3682d@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<5c5a74a0d87db11dd1519248d8fda5c8fa9826be.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5c5a74a0d87db11dd1519248d8fda5c8fa9826be.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:38 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Add non-locking __media_entity_pipeline_start/stop() interfaces
> to be called from code paths that hold the graph_mutex. For this
> change, the media_entity_pipeline_start() routine is renamed to
> __media_entity_pipeline_start() minus the graph_mutex lock and
> unlock. media_entity_pipeline_start() now calls the non-locking
> __media_entity_pipeline_start() holding the graph_lock. The stop
> interface, media_entity_pipeline_stop() routine is renamed to
> __media_entity_pipeline_stop() minus the graph_mutex lock and
> unlock. media_entity_pipeline_stop() now calls the non-locking
> __media_entity_pipeline_stop() holding the graph_lock.

Please write a better patch descriptions. The above could easily
be split into 3 or 4 paragraphs, with would make it easier to
read.

Also, too much details, written on a spaghetti style;)

It is obvious by anyone that looked at the patch that
"media_entity_pipeline_start() routine is renamed to 
__media_entity_pipeline_start() minus the graph_mutex lock and
unlock."

I read exactly the same thing at the C code, *and* at the
subject of the e-mail. Patch subject/description should tell
what, why and how (but you should not repeat what can easily
be inferred from looking at the diff).

I would describe it as:

   Currently, media pipeline graph traversal routines take
   the graph_mutex lock.

   While this works for the current code, we'll need 
   unlocked versions of them because
   (some explanation *why* you need it, with is the main
    thing that should be at the description).

   So, add non-locking media_entity_pipeline_start/stop()
   variations.

> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/media-entity.c | 34 ++++++++++++++++++++++++----------
>  include/media/media-entity.h | 12 ++++++++++++
>  2 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 9b4d712..b78e4c2 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -365,8 +365,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
>   * Pipeline management
>   */
>  
> -__must_check int media_entity_pipeline_start(struct media_entity *entity,
> -					     struct media_pipeline *pipe)
> +__must_check int __media_entity_pipeline_start(struct media_entity *entity,
> +					       struct media_pipeline *pipe)
>  {
>  	struct media_device *mdev = entity->graph_obj.mdev;
>  	struct media_entity_graph *graph = &pipe->graph;
> @@ -374,8 +374,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  	struct media_link *link;
>  	int ret;
>  
> -	mutex_lock(&mdev->graph_mutex);
> -
>  	if (!pipe->streaming_count++) {
>  		ret = media_entity_graph_walk_init(&pipe->graph, mdev);
>  		if (ret)
> @@ -456,8 +454,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  		}
>  	}
>  
> -	mutex_unlock(&mdev->graph_mutex);
> -
>  	return 0;
>  
>  error:
> @@ -487,19 +483,28 @@ error_graph_walk_start:
>  	if (!--pipe->streaming_count)
>  		media_entity_graph_walk_cleanup(graph);
>  
> -	mutex_unlock(&mdev->graph_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
>  
> +__must_check int media_entity_pipeline_start(struct media_entity *entity,
> +					     struct media_pipeline *pipe)
> +{
> +	struct media_device *mdev = entity->graph_obj.mdev;
> +	int ret;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +	ret = __media_entity_pipeline_start(entity, pipe);
> +	mutex_unlock(&mdev->graph_mutex);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
>  
> -void media_entity_pipeline_stop(struct media_entity *entity)
> +void __media_entity_pipeline_stop(struct media_entity *entity)
>  {
> -	struct media_device *mdev = entity->graph_obj.mdev;
>  	struct media_entity_graph *graph = &entity->pipe->graph;
>  	struct media_pipeline *pipe = entity->pipe;
>  
> -	mutex_lock(&mdev->graph_mutex);
>  
>  	WARN_ON(!pipe->streaming_count);
>  	media_entity_graph_walk_start(graph, entity);
> @@ -516,6 +521,15 @@ void media_entity_pipeline_stop(struct media_entity *entity)
>  	if (!--pipe->streaming_count)
>  		media_entity_graph_walk_cleanup(graph);
>  
> +}
> +EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
> +
> +void media_entity_pipeline_stop(struct media_entity *entity)
> +{
> +	struct media_device *mdev = entity->graph_obj.mdev;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +	__media_entity_pipeline_stop(entity);
>  	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index fe485d3..c7583db 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -832,6 +832,12 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
>   */
>  __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  					     struct media_pipeline *pipe);
> +/**
> + * non-locking __media_entity_pipeline_start() can be called from
> + * code paths that hold the graph_mutex
> + */
> +__must_check int __media_entity_pipeline_start(struct media_entity *entity,
> +					       struct media_pipeline *pipe);
>  
>  /**
>   * media_entity_pipeline_stop - Mark a pipeline as not streaming
> @@ -848,6 +854,12 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  void media_entity_pipeline_stop(struct media_entity *entity);
>  
>  /**
> + * non-locking __media_entity_pipeline_stop() can be called from
> + * code paths that hold the graph_mutex
> + */
> +void __media_entity_pipeline_stop(struct media_entity *entity);
> +
> +/**
>   * media_devnode_create() - creates and initializes a device node interface
>   *
>   * @mdev:	pointer to struct &media_device
