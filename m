From: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Fri, 6 Feb 2015 15:41:58 +0000
Message-ID: <20150206154157.GD1143@localhost.localdomain>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
 <20150206125916.GB26247@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150206125916.GB26247-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "James E.J. Bottomley (JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org)" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 06, 2015 at 04:59:16AM -0800, Greg KH wrote:
> On Fri, Feb 06, 2015 at 12:20:53AM +0000, Seymour, Shane M wrote:
> > The current patch that implements tape statistics is here:
> > 
> > http://marc.info/?l=linux-scsi&m=142112067313723&w=2
> 
> Aside from the "do we want to do this all in a single file" issue that I
> will say more on below, this patch has issues.  Please don't use a
> kobject for _ANYTHING_ in sysfs that has a struct device as a parent.
> If you do that, it can't be seen by userspace tools very well, if at
> all.

I can't speak for Shane but wouldn't spend too much time looking at the
current v2 patch: it's the result of a pretty ugly compromise suggested
on linux-scsi.

This thread was really to try to settle the discussion on the structure
of the stats files.

> > Recently there was was another discussion here about one file vs a collection of files for tape statistics:
> > 
> > http://marc.info/?l=linux-scsi&m=142316255501550&w=2
> > 
> > The result was that I should ask here what method I should use. I
> > would like to get feedback in relation to tape statistics and one file
> > vs multi-file in sysfs. I'm happy to keep the existing code or change
> > to a single file approach.
> 
> One of the primary reasons we created sysfs and the "one value per file"
> rule is that multi-value files just do not work well.  Yes, you get an
> atomic snapshot, and you save some open/read/close syscall roundtrips,
> but you do so at the expense of forcing userspace to "know" what the
> format of the file is.  And once you create it, you can NEVER CHANGE IT
> AGAIN.

I am not convinced this is a concern for tape statistics: they are pretty
much a solved problem. The commercial *nixes have had this for decades.

Likewise for disk stats: although fluff like maj:min/name etc. has been
shuffled a few times the basic fields have remained unchanged for a very
long time and sysfs already removes the need to include an identity
field.
 
> Yes, that's right, if you come up with some new statistic in the future,
> or realize that one of the ones you have now is wrong, you can't change
> it, you have to make a whole new file, otherwise you could break
> userspace tools.

I understand the fact that you can't change them; I just don't think it's
a big problem in this specific case (and much less than some of the
more imaginative sysfs content - 2d int arrays with column headers
anyone?).

> And yes, open/read/close does take take a few extra cycles, but you
> can't really measure it for a virtual filesystem like this on any modern
> system.

I'll try to get some numbers when I get back home next week - Shane is
talking about use cases involving tens of thousands of tape devices. I
am not certain that the overhead would be unmeasurable in that case: the
additional context switching & TLB flushes alone seem like they would
add up.

> Hope this helps explain why we have the sysfs rule, and why you should
> continue to follow it as well.
>
> Yes, it's not always followed, but that's usually because people forgot
> why we had this rule, and no one noticed or pointed it out to me that it
> was wrong.

Perhaps sysfs.txt should be updated to make the position more clear? The
current wording seems rather more liberal than this thread would
suggest. Maybe something like the patch below?

This would help people who are trying to dtrt by reading the documentation.

Regards,
Bryn.


  From 3081aad4cc4d19b68f39499dbeb3837f0642f70e Mon Sep 17 00:00:00 2001
  From: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
  Date: Fri, 6 Feb 2015 15:19:39 +0000
  Subject: [PATCH] docs/sysfs: Specify array valued attribute review
   requirements
  
  Although the linux-api position that one-value-per-file is a strong rule
  is very clear in mailing list discussions the sysfs.txt documentation
  suggests a rather more liberal stance:
  
  "... it is socially acceptable to express an array of values of the same
  type."
  
  Fix the documentation to make it clear that such uses should be
  discussed on linux-api first.

Signed-off-by: Bryn M. Reeves <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/filesystems/sysfs.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index b35a64b..494fa78 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -57,8 +57,15 @@ attributes.
 
 Attributes should be ASCII text files, preferably with only one value
 per file. It is noted that it may not be efficient to contain only one
-value per file, so it is socially acceptable to express an array of
-values of the same type. 
+value per file, so it may be socially acceptable to express an array of
+values of the same type.
+
+If you are considering adding such an array attribute to sysfs please
+discuss it via the linux-api mailing list first to ensure that your
+proposed use is acceptable:
+
+  https://www.kernel.org/doc/man-pages/linux-api-ml.html
+  linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 
 Mixing types, expressing multiple lines of data, and doing fancy
 formatting of data is heavily frowned upon. Doing these things may get
-- 
1.9.3
