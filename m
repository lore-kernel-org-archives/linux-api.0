From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [LSF/MM TOPIC ATTEND] thawing the fsnotify subsyetm
Date: Fri, 20 Jan 2017 09:47:51 +0100
Message-ID: <20170120084751.GB14115@quack2.suse.cz>
References: <CAOQ4uxh9ZbSfO-6V6cYNbNd2eBvVV6MxBCnpSzyp3-zKrYeWWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh9ZbSfO-6V6cYNbNd2eBvVV6MxBCnpSzyp3-zKrYeWWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 19-01-17 16:28:09, Amir Goldstein wrote:
> My employer has a use case of watching file system changes
> over millions of directories.
> 
> It so happens that the same product (cloud sync) also runs on
> Windows and on MacOS. both OS have a scalable API to monitor
> file systems changes over millions of directories.
> 
> Since the product requires being notified on filename events
> (e.g. create/delete/rename), the only available option on Linux is
> inotify, but inotify does not scale well to millions of directories
> use case and not a the right tool for the job in general.
> 
> For that purpose, I implemented fanotify super block watch [1],
> to be able to:
> 1. report filename events
> 2. watch over file system root (as opposed to mount point)
> 3. report event information using struct file_handle,
>     instead of keeping open file descriptor per event
 
Yeah, I think this would be worth a discussion. I've got other requests for
similar functionality so Amir is not the only one with the needs. But given
how unsuccessful we have been with file change notification API in the past
I'm very conservative about its extensions and would prefer to have wider
discussion about this.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
