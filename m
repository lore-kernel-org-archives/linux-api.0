From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] headers_check: don't warn about kexec.h
Date: Tue, 13 Jan 2015 21:27:08 +0100
Message-ID: <2363197.VbAKlSiQLX@wuerfel>
References: <12825174.7oxZXDxNhV@wuerfel> <1421169212.15397.22.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421169212.15397.22.camel@x220>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 13 January 2015 18:13:32 Paul Bolle wrote:
> 
> For the seqbuf_dump() stuff there are apparently users. I forgot the
> details, but the sound people wanted to keep that declaration (and some
> related ancient things) in the header involved to keep some really
> ancient stuff buildable.
> 
> But the kexec_load declaration isn't very useful for userspace, see the
> patch I submitted in
> http://lkml.kernel.org/r/1389791824.17407.9.camel@x220 . And After my
> attempt the export of that declaration has also been discussed in
> http://lkml.kernel.org/r/115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org 
> 
> In that last discussion no one has been able to point to an actual user
> of it. So, as far as I can tell, no one actually uses it. Which makes
> sense, because including this header by itself doesn't give one access
> to a useful definition of kexec_load. So why bother with the
> declaration?
> 
> The last time that Geoff has been trying to get that patch applied
> should be
> http://lkml.kernel.org/r/b0702fc4186db21820d686e89afd6480560823db.1415837218.git.geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org  I'd rather see that go in.
> 

Fine with me as well. As long as we can find someone to take one of 
the patches, I'm happy.

	Arnd
