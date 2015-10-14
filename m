From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 5/9] vfs: Copy shouldn't forbid ranges inside the same
 file
Date: Wed, 14 Oct 2015 11:25:23 -0700
Message-ID: <20151014182523.GA31225@infradead.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-6-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142233.GC31867@infradead.org>
 <561E92C9.7040205@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <561E92C9.7040205@Netapp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com
List-Id: linux-api@vger.kernel.org

On Wed, Oct 14, 2015 at 01:37:13PM -0400, Anna Schumaker wrote:
> I would have folded this and patch 4 earlier if I had written patch 1,
> but I didn't feel comfortable modifying Zach's work too much.  I can
> make that change if it's not really a problem.

Folding the changes is perfectly fine, just make it clear you changed
it, e.g.

Signed-off-by: Original Author <original@auhor.info>
[anna: fixed foo & bar, rewrote changelog]
Signed-off-by: Anna Schumaker <Anna.Schumaker@netapp.com>
