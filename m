From: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Wed, 08 Mar 2017 19:48:11 +0100
Message-ID: <1488998891.5155.20.camel@quad>
References: <1488897868.5178.3.camel@quad>
         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f7f9f60b-0f39-7dce-1778-3aa40ba198ef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2017-03-08 at 12:54 -0500, Carlos O'Donell wrote:
> In glibc we limit setuid applications, for example sanitizing their
> environment where it would cause problems or alter behaviour in 
> unintended ways.

Please explain what these limitations are, and when they were imposed,
as in the article
https://googleprojectzero.blogspot.nl/2014/08/the-poisoned-nul-byte-2014-edition.html
the author is actually using a setuid binary (pkexec) and clearly not
running into any limitations with that particular exploit.

Also note that heap spraying can happen in any binary that has memory
leaks in its option parsing. pkexec.c and pkcheck.c are known to suffer
such issues, but other binaries could be affected. Setting
MAX_ARG_STRINGS to a sensible value significantly reduces the impact of
such heap spraying.

Regards,
Leonard.

-- 
mount -t life -o ro /dev/dna /genetic/research
