From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to
 dmi_decode_table
Date: Fri, 17 Apr 2015 14:50:15 +0200
Message-ID: <20150417145015.1f7a1762@endymion.delvare>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
	<20150415143530.GF4804@codeblueprint.co.uk>
	<20150416103511.55927ccc@endymion.delvare>
	<553018BB.1080903@globallogic.com>
	<20150417105454.1c52f430@endymion.delvare>
	<5530DC41.3050700@globallogic.com>
	<5530F6C7.6060306@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5530F6C7.6060306-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 17 Apr 2015 15:04:23 +0300, Ivan.khoronzhuk wrote:
> On 17.04.15 13:11, Ivan.khoronzhuk wrote:
> > On 17.04.15 11:54, Jean Delvare wrote:
> >> I have no formal tree yet, but my current patch set can be seen at:
> >> http://jdelvare.nerim.net/devel/linux-3/jdelvare-dmi/
> >>
> >> First 2 patches from you are already upstream. You should rebase your
> >> updated patch series on top of upstream + patches 03 and 04, as they
> >> will go in first.
> >
> > Not sure that's a good idea to base on patches that doesn't path any 
> > review and
> > no one cannot apply. At least it be good you send them that I can 
> > point on them in
> > commit message.
> 
> Don't know why your patches don't apply on top of linux next.
> They looks w/o conflicts. I've applied them by hand. To avoid mess, 
> could you
> please send them in order I can refer on them in my commit message.

Sorry, I had the the whitespace wrong when backporting one of your two
old patches, so I ended up with a code base different from what upstream
has. It's all fixed now, you can download the patches again and they
should apply fine (starting from 01 if working with kernel v4.0,
starting from 03 if working with linux-next.) Sorry for the trouble.

The reason why my patch series is based on v4.0 and not linux-next is
that I'm going to test it on a remote development system which
implements SMBIOS 3.0 and is currently running kernel v4.0, so I don't
want to use an unstable code base which could cause problems by itself.

-- 
Jean Delvare
SUSE L3 Support
