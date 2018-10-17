From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock for reconfiguration [ver #12]
Date: Wed, 17 Oct 2018 22:20:55 +0100
Message-ID: <6469.1539811255@warthog.procyon.org.uk>
References: <7b409325-9e23-aa5e-916f-cb362a6940aa@gmail.com> <f6f2553e-f64d-9c26-4290-baf43e5f533b@gmail.com> <19866.1539782101@warthog.procyon.org.uk> <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com> <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk> <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk> <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com> <20181013061141.GR32577@ZenIV.linux.org.uk> <28710.1539782412@warthog.procyon.org.uk> <15867.1539791153@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7b409325-9e23-aa5e-916f-cb362a6940aa@gmail.com>
Content-ID: <6468.1539811255.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Alan Jenkins <alan.christopher.jenkins@gmail.com> wrote:

> static  int  do_remount <https://elixir.bootlin.com/linux/v4.18/ident/do_remount>(struct  path <https://elixir.bootlin.com/linux/v4.18/ident/path>  *path <https://elixir.bootlin.com/linux/v4.18/ident/path>,  int  ms_flags,  int  sb_flags,
> 		int  mnt_flags,  void  *data)

What happened there?  You seem to have had a load of URLs substituted in.

David
