From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 4/7] selftests: add memfd_create() + sealing tests
Date: Wed, 16 Jul 2014 03:07:37 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1407160307160.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com> <1402655819-14325-5-git-send-email-dh.herrmann@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1402655819-14325-5-git-send-email-dh.herrmann@gmail.com>
Sender: owner-linux-mm@kvack.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>, john.stultz@linaro.org, Lennart Poettering <lennart@poettering.net>, Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>, Hugh Dickins <hughd@google.com>, Tony Battersby <tonyb@cybernetics.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Fri, 13 Jun 2014, David Herrmann wrote:

> Some basic tests to verify sealing on memfds works as expected and
> guarantees the advertised semantics.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Thanks for whatever the fix was, I didn't hit any problem running
this version repeatedly, on 64-bit and on 32-bit.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
