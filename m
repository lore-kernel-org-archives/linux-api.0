From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/11] UAPI: bcache: Fix use of embedded flexible array
Date: Tue, 09 Oct 2018 16:41:06 +0100
Message-ID: <17992.1539099666@warthog.procyon.org.uk>
References: <nycvar.YFH.7.76.1810021622320.11696@n3.vanv.qr> <153616290368.23468.7806230605345568524.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1810021622320.11696@n3.vanv.qr>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:

> """it [the array size expression] shall be a converted constant expression of
> type std::size_t and its value shall be greater than zero."""
> —http://eel.is/c++draft/dcl.array

Interesting.  You're not actually quoting the full sentence:

	If the constant-expression is present, it shall be a converted
	constant expression of type std​::​size_­t and its value shall be
	greater than zero.

This suggests that:

	__u64 ptr[]

is actually valid since:

	D1 [ constant-expressionopt ] attribute-specifier-seqopt

suggests that the part between the brackets is optional.

David
