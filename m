From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Date: Sat, 5 Mar 2011 01:22:16 +0200
Message-ID: <20110304232216.GA18343@shutemov.name>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name>
 <1299084001-3916-2-git-send-email-kirill@shutemov.name>
 <1299265422.22521.2.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1299265422.22521.2.camel@laptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 04, 2011 at 08:03:42PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-03-02 at 18:40 +0200, Kirill A. Shutsemov wrote:
> > -       if (ret < current->timer_slack_ns)
> > -               return current->timer_slack_ns;
> > -       return ret;
> > +       return clamp(__estimate_accuracy(&now),
> > +                       get_task_timer_slack(current), LONG_MAX);
> 
> That actually makes the code worse, how about:
> 
>   min(__estimate_accuracy(), get_task_timer_slack()) ?

It's better. Thanks.

-- 
 Kirill A. Shutemov
