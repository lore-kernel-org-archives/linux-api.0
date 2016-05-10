From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v21 00/22] Richacls
Date: Tue, 10 May 2016 10:20:22 +0200
Message-ID: <20160510082022.GC26892@sernet.de>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
 <20160510041809.GB1079@sernet.de>
 <20160510081150.GA3411@jeremy-ThinkPad-T430s>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160510081150.GA3411@jeremy-ThinkPad-T430s>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 10, 2016 at 10:11:50AM +0200, Jeremy Allison wrote:
> +1 from me. This is something that many vendors need
> and have needed for a very long time. Getting this
> in will allow *large* amounts of existing storage to
> be migrated to Linux.

ZFS has NFSv4 richacls, and people seem to risk shitstorms
for ZFS. Not only for this of course, but they do
contribute.

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
