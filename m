From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Fri, 6 Feb 2015 04:59:16 -0800
Message-ID: <20150206125916.GB26247@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3EADA-4I1V4pQFGigSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "James E.J. Bottomley (JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org)" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 06, 2015 at 12:20:53AM +0000, Seymour, Shane M wrote:
> Hello linux-api'ers
> 
> There has been some ongoing discussion about the best way to implement tape statistics. The original method suggested a long time ago used a single file in sysfs similar to block statistics in sysfs. That lead to an impass about the code on the linux-scsi mailing list.
> 
> The sysfs documentation says that files should contain one item per file (with some small exceptions):
> 
> > "Attributes should be ASCII text files, preferably with only one value
> > per file. It is noted that it may not be efficient to contain only one
> > value per file, so it is socially acceptable to express an array of
> > values of the same type."
> 
> The current patch that implements tape statistics is here:
> 
> http://marc.info/?l=linux-scsi&m=142112067313723&w=2

Aside from the "do we want to do this all in a single file" issue that I
will say more on below, this patch has issues.  Please don't use a
kobject for _ANYTHING_ in sysfs that has a struct device as a parent.
If you do that, it can't be seen by userspace tools very well, if at
all.

Instead, if you want to create a directory, just use an attribute group,
which will be created at the proper time (before the device is announced
to userspace), and then userspace can see it with the tools it is used
to using (i.e. libudev and friends.)

That should simplify your code a lot, please make that change no matter
what happens here with the content of the files.

> Recently there was was another discussion here about one file vs a collection of files for tape statistics:
> 
> http://marc.info/?l=linux-scsi&m=142316255501550&w=2
> 
> The result was that I should ask here what method I should use. I
> would like to get feedback in relation to tape statistics and one file
> vs multi-file in sysfs. I'm happy to keep the existing code or change
> to a single file approach.

One of the primary reasons we created sysfs and the "one value per file"
rule is that multi-value files just do not work well.  Yes, you get an
atomic snapshot, and you save some open/read/close syscall roundtrips,
but you do so at the expense of forcing userspace to "know" what the
format of the file is.  And once you create it, you can NEVER CHANGE IT
AGAIN.

Yes, that's right, if you come up with some new statistic in the future,
or realize that one of the ones you have now is wrong, you can't change
it, you have to make a whole new file, otherwise you could break
userspace tools.

Instead, a one-value-per-file rule forces userspace to know that if the
file is present, it can be opened and read from for a single value.  If
it isn't there, it should fail properly and move on to the next
statistic.  If you want to add a new statistic, great, just add a new
file and you are set.

You aren't dealing with performance-sensitive numbers here that "have"
to have an atomic snapshot of the state at a specific point in time in
order to work properly, so just have a bunch of files, all one value per
file, then all userspace tools will "just work" (i.e. libudev), and
everyone is happy.

And yes, open/read/close does take take a few extra cycles, but you
can't really measure it for a virtual filesystem like this on any modern
system.

Hope this helps explain why we have the sysfs rule, and why you should
continue to follow it as well.

Yes, it's not always followed, but that's usually because people forgot
why we had this rule, and no one noticed or pointed it out to me that it
was wrong.

thanks,

greg k-h
