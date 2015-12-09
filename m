From: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] test: firmware_class: add asynchronous request
 trigger
Date: Wed, 9 Dec 2015 14:12:20 -0800
Message-ID: <20151209221220.GB51175@google.com>
References: <1449628714-66641-1-git-send-email-computersforpeace@gmail.com>
 <1449628714-66641-2-git-send-email-computersforpeace@gmail.com>
 <CAGXu5jJ=JKN9FJzjonixhfNFZxgZ_y74cSkyG1DWPp3BS3VJ7g@mail.gmail.com>
 <20151209214843.GA51175@google.com>
 <CAGXu5jLGp315GdOWQyamD8awzrdZDFoNVWQozTFdjQAjrtRN0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLGp315GdOWQyamD8awzrdZDFoNVWQozTFdjQAjrtRN0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 09, 2015 at 02:05:17PM -0800, Kees Cook wrote:
> On Wed, Dec 9, 2015 at 1:48 PM, Brian Norris
> <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > I was also thinking, since use-after-free isn't necessarily immediately
> > obvious (this worked fine in my testing), that maybe we could poison the
> > buffer before kfree()'ing? Like:
> >
> >         name = ...;
> >         len = strlen(name);
> >
> >         ...
> >
> >         rc = request_firmware_nowait(...);
> >         if (rc) {
> >                 pr_info("...");
> >                 kfree(name);
> >                 goto out;
> >         }
> >         /*
> >          * Clear out the name, to test for race conditions with the
> >          * async request
> >          */
> >         memset(name, 0, len);
> >         kfree(name);
> 
> Hrm, well, I'm not against it, but I think running under KASan is
> probably the right way to find these things. But, might as well, just
> to notice any regressions.

Fair enough. The memset probably isn't that useful.

BTW, one reason I didn't notice my use-after-free is that the "use" was
under an error path that I didn't exercise. I need to remember to turn
my brain back on.

Brian
