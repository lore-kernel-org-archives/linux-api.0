From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] headers_check: don't warn about kexec.h
Date: Tue, 13 Jan 2015 18:13:32 +0100
Message-ID: <1421169212.15397.22.camel@x220>
References: <12825174.7oxZXDxNhV@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <12825174.7oxZXDxNhV@wuerfel>
Sender: linux-kbuild-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geoff Levand <geoff@infradead.org>, Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Arnd,

On Tue, 2015-01-13 at 17:19 +0100, Arnd Bergmann wrote:
> We've been getting this warning for ages:
> 
> ./usr/include/linux/kexec.h:61: userspace cannot reference function or variable defined in the kernel
> 
> There is no proper fix for this file, as the declaration is meant for
> user space, not for the kernel, so we should work around it the
> same way that we treat the seqbuf_dump() definition.

For the seqbuf_dump() stuff there are apparently users. I forgot the
details, but the sound people wanted to keep that declaration (and some
related ancient things) in the header involved to keep some really
ancient stuff buildable.

But the kexec_load declaration isn't very useful for userspace, see the
patch I submitted in
http://lkml.kernel.org/r/1389791824.17407.9.camel@x220 . And After my
attempt the export of that declaration has also been discussed in
http://lkml.kernel.org/r/115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org 

In that last discussion no one has been able to point to an actual user
of it. So, as far as I can tell, no one actually uses it. Which makes
sense, because including this header by itself doesn't give one access
to a useful definition of kexec_load. So why bother with the
declaration?

The last time that Geoff has been trying to get that patch applied
should be
http://lkml.kernel.org/r/b0702fc4186db21820d686e89afd6480560823db.1415837218.git.geoff@infradead.org  I'd rather see that go in.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> index 62320f93e903..fb051848667c 100755
> --- a/scripts/headers_check.pl
> +++ b/scripts/headers_check.pl
> @@ -69,6 +69,10 @@ sub check_declarations
>  	if ($line =~ m/^void seqbuf_dump\(void\);/) {
>  		return;
>  	}
> +	# user-only declaration from kexec.h
> +	if ($line =~ m/^extern int kexec_load/) {
> +		return;
> +	}
>  	if ($line =~ m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
>  		printf STDERR "$filename:$lineno: " .
>  			      "userspace cannot reference function or " .

Regards,


Paul Bolle

