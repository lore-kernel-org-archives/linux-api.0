From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 2/6] xstat: Ext4: Return extended attributes
Date: Thu, 26 Apr 2012 12:00:37 -0500
Message-ID: <CAH2r5muSz63aCJ56ExrXV2gmLQjmUhbnrpKT0RnRoXRQL3RtoQ@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419140625.17272.23303.stgit@warthog.procyon.org.uk>
	<CAH2r5mtHj6LnOcRDv37_S-tZmc42sTLwE8Z02+27XZbjEVzZfg@mail.gmail.com>
	<18841.1335448056@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <18841.1335448056@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 8:47 AM, David Howells <dhowells@redhat.com> wr=
ote:
> Steve French <smfrench@gmail.com> wrote:
>
>> This patch reminds me of a question on time stamps - how can an
>> application query the time granularity ie sb_s_time_gran for a mount
>> (e.g. 1 second for some file systems, 100 nanoseconds for cifs/smb2,=
 1
>> nanosecond for others etc.)
>
> Ummm... =A0In what context? =A0With the proposed xstat() interface it=
 will be
> provided.

great (although I thought it would be "stat -f" property).


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
