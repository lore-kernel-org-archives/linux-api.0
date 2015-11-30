From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Mon, 30 Nov 2015 17:53:18 -0500
Message-ID: <20151130225318.GD9039@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
 <20151124161630.GL17033@mtj.duckdns.org>
 <20151127052511.GA25490@mail.hallyn.com>
 <20151130151147.GG3535@mtj.duckdns.org>
 <20151130183758.GA25433@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151130183758.GA25433@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: serge@hallyn.com, linux-kernel@vger.kernel.org, adityakali@google.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

Hello, Serge.

On Mon, Nov 30, 2015 at 12:37:58PM -0600, Serge E. Hallyn wrote:
> > Yeah, I agree but the name is kinda misleading tho.  The output isn't
> > really a relative path but rather absolute path against the specified
> > root.  Maybe updating the function and parameter names would be
> > helpful?
> > 
> 
> Ok - updating the comment is simple enough.  Though the name/params
> kernfs_path_from_node_locked(from, to) still seem to make sense.  Would
> you prefer something like kernfs_absolute_path_from node_locked()?  I
> hesitate to call 'from' 'root' since kernfs_root is a thing and this
> is not that.

Hmmm... I see.  Let's just make sure that the comment is clear about
the fact that it calculates (pseudo) absolute path rather than
relative path.

Thanks.

-- 
tejun
