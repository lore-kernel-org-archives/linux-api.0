From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 23:21:08 +0100
Message-ID: <87wr522kyz.fsf@spindle.srvr.nix>
References: <20120426182524.E5ADF2C0EC@topped-with-meat.com>
	<20120419163238.61D382C0DF@topped-with-meat.com>
	<20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<19184.1335448455@redhat.com> <9931.1335477281@redhat.com>
	<20120426220242.53FC22C0D3@topped-with-meat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-28039-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <20120426220242.53FC22C0D3@topped-with-meat.com> (Roland
	McGrath's message of "Thu, 26 Apr 2012 15:02:42 -0700 (PDT)")
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Roland McGrath <roland@hack.frob.com>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On 26 Apr 2012, Roland McGrath verbalised:

>> fileinfoat() perhaps?  I think stat*at() is better, though, as people are
>> used to the stat function family.
>
> Names like that were all I had thought of when I said I hadn't thought of
> any good ones. ;-)

Quite. It's a garden-path function name. "What's a foat and why would I
want to put a file in one?"

-- 
NULL && (void)
