From: Johannes Hirte <johannes.hirte@datenkhaos.de>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Fri, 6 Dec 2019 22:47:25 +0100
Message-ID: <20191206214725.GA2108@latitude>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2019 Okt 23, David Howells wrote:
> Convert pipes to use head and tail pointers for the buffer ring rather than
> pointer and length as the latter requires two atomic ops to update (or a
> combined op) whereas the former only requires one.

This change breaks firefox on my system. I've noticed that some pages
doesn't load correctly anymore (e.g. facebook, spiegel.de). The pages
start loading and than stop. Looks like firefox is waiting for some
dynamic loading content. I've bisected to this commit, but can't revert
because of conflicts.

-- 
Regards,
  Johannes Hirte
