From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to
 dmi_decode_table
Date: Thu, 16 Apr 2015 10:35:11 +0200
Message-ID: <20150416103511.55927ccc@endymion.delvare>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
	<20150415143530.GF4804@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150415143530.GF4804-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Matt,

On Wed, 15 Apr 2015 15:35:30 +0100, Matt Fleming wrote:
> On Thu, 02 Apr, at 03:57:01PM, Ivan Khoronzhuk wrote:
> > The "dmi_table" function looks like data instance, but it does DMI
> > table decode. This patch renames it to "dmi_decode_table" name as
> > more appropriate. That allows us to use "dmi_table" name for correct
> > purposes.
> > 
> > Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
> > ---
> >  drivers/firmware/dmi_scan.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Looks good to me.
> 
> Jean, do you want me to pick this patch up or are you going to?

Good question, we need to agree on a strategy.

There are 3 patch sets to consider here.

1* My patch fixing the UUID ordering bug. It must go in first and
   immediately, as it fixes a regression and will have to be backported
   to stable branches.

2* 2 older patches from Ivan which are currently in your efi-next tree
   if I'm not mistaken. Both were based on an old tree so they do not
   apply cleanly on kernel v4.0, I had to fix them up manually. I have
   no idea if git would be able to merge them properly, as the fix
   above changed the context even more.

3* The 3 new patches from Ivan which I am reviewing now, which are not
   applied in any public tree AFAIK.

I don't really care who picks these patches up and sends them to Linus,
but I think they should all follow the same route so that Linus has as
little merge work to do as possible. So either you pick them all, or I
do. If I do, you'll have to drop the 2 patches you have in efi-next.
Again I'm fine either way, so please let me know what makes your life
easier and let's do that.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
