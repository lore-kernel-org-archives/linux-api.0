From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v7 5/4] copy_file_range.2: New page documenting
 copy_file_range()
Date: Sun, 25 Oct 2015 20:39:25 -0700
Message-ID: <20151026033925.GA9945@infradead.org>
References: <1445628736-13058-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1445628736-13058-6-git-send-email-Anna.Schumaker@Netapp.com>
 <562B734D.50800@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <562B734D.50800-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: P??draig Brady <P@draigBrady.com>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 24, 2015 at 01:02:21PM +0100, P??draig Brady wrote:
> I'm a bit worried about the sparse expansion and default reflinking
> which might preclude cp(1) from using this call in most cases, but I =
will
> test and try to use it. coreutils has heuristics for determining if f=
iles
> are remote, which we might use to restrict to that use case.

Can you explain why reflinking and hole expansion are an issue if done
locally and not if done remotely?  I'd really like to make the call as
usable as possible for everyone, but we really need clear sem=E5ntics f=
or
that.

Also note that Annas current series allows for hole filling - any decen=
t
implementation should not do them, but that's really a quality of
implementation and not an interface issue.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
