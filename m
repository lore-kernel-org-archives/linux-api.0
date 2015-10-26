From: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v7 5/4] copy_file_range.2: New page documenting
 copy_file_range()
Date: Mon, 26 Oct 2015 12:19:33 +0000
Message-ID: <562E1A55.4050409@draigBrady.com>
References: <1445628736-13058-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1445628736-13058-6-git-send-email-Anna.Schumaker@Netapp.com>
 <562B734D.50800@draigBrady.com> <20151026033925.GA9945@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151026033925.GA9945-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 26/10/15 03:39, Christoph Hellwig wrote:
> On Sat, Oct 24, 2015 at 01:02:21PM +0100, P??draig Brady wrote:
>> I'm a bit worried about the sparse expansion and default reflinking
>> which might preclude cp(1) from using this call in most cases, but I=
 will
>> test and try to use it. coreutils has heuristics for determining if =
files
>> are remote, which we might use to restrict to that use case.
>=20
> Can you explain why reflinking and hole expansion are an issue if don=
e
> locally and not if done remotely?  I'd really like to make the call a=
s
> usable as possible for everyone, but we really need clear sem=EF=BF=BD=
ntics for
> that.

=46air point on local vs remote. I was just assuming that remote
copy offload would not do reflinking on the backend, or at
least wasn't an exposed option over the remote interface.

I get the impression that you think reflinking should be hidden
from the user, i.e. cp(1) should not have had the --reflink option
(for the last 6 years)?  I'm not convinced of that, and even so
I think lower level interfaces would benefit from finer grained options=
=2E
This would be especially useful since there is no general interface
to reflink at present. I was happy with the reflink control options,
thinking the extra control could allow cp to use this by default.

> Also note that Annas current series allows for hole filling - any dec=
ent
> implementation should not do them, but that's really a quality of
> implementation and not an interface issue.

I think you're saying the default `cp --sparse=3Dauto` operation
could rely on copy_file_range(...complete file...), while
cp --sparse=3D{always,never} would have to iterate over the
file, punching or filling holes as appropriate. I thought
Anna indicated differently wrt splice filling holes by default.

TBH I'm not clear on the semantics of the current implementation,
so need to test the above in various cases.

thanks,
P=C3=A1draig.
