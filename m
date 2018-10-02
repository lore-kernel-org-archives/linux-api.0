From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 04/11] UAPI: bcache: Fix use of embedded flexible array
Date: Tue, 2 Oct 2018 16:52:56 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1810021622320.11696@n3.vanv.qr>
References: <153616290368.23468.7806230605345568524.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153616290368.23468.7806230605345568524.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


On Wed, 05 Sep 2018 16:55:03 +0100, David Howells wrote:
>
>The bkey struct defined by bcache is embedded in the jset struct. However,
>this is illegal in C++ as there's a "flexible array" at the end of the struct.
>Change this to be a 0-length struct instead.
>
>-	__u64	ptr[];
>+	__u64	ptr[0];

As per the C++ standard, it is _also_ illegal to declare an array of size zero.

"""it [the array size expression] shall be a converted constant expression of
type std::size_t and its value shall be greater than zero."""
—http://eel.is/c++draft/dcl.array

That makes both "__u64 ptr[]" and "__u64 ptr[0]" *implementation-specific
extensions*.


3rd party tooling (concerns both C and C++):

Coverity Scan (IIRC) treats "__u64 ptr[0]" as an array of "definitely-zero"
size. Writing to any element will outright flag an out-of-bounds violation.
That is sensible, since only "ptr[]" was standardized.


Conclusion:

So please, do never use __u64 ptr[0].
