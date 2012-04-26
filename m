From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/6] xstat: Ext4: Return extended attributes
Date: Thu, 26 Apr 2012 14:47:36 +0100
Message-ID: <18841.1335448056@redhat.com>
References: <CAH2r5mtHj6LnOcRDv37_S-tZmc42sTLwE8Z02+27XZbjEVzZfg@mail.gmail.com> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419140625.17272.23303.stgit@warthog.procyon.org.uk>
Return-path: <libc-alpha-return-27983-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <CAH2r5mtHj6LnOcRDv37_S-tZmc42sTLwE8Z02+27XZbjEVzZfg@mail.gmail.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> This patch reminds me of a question on time stamps - how can an
> application query the time granularity ie sb_s_time_gran for a mount
> (e.g. 1 second for some file systems, 100 nanoseconds for cifs/smb2, 1
> nanosecond for others etc.)

Ummm...  In what context?  With the proposed xstat() interface it will be
provided.

David
