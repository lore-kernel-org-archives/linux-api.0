From: Cyrill Gorcunov <gorcunov@virtuozzo.com>
Subject: Re: [PATCH] inotify: Extend ioctl to allow to request id of new
 watch descriptor
Date: Thu, 8 Feb 2018 20:58:33 +0300
Message-ID: <20180208175833.GC17303@uranus.lan>
References: <151810242614.30935.12876744458891870220.stgit@localhost.localdomain>
 <20180208161400.t4i42kkpddm2k766@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180208161400.t4i42kkpddm2k766@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, akpm@linux-foundation.org, amir73il@gmail.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 08, 2018 at 05:14:00PM +0100, Jan Kara wrote:
> > 
> > Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> 
> I'm not thrilled by this but OTOH I also don't know about a better option.
> The patch as such looks OK to me so unless someone objects I'll take it to
> my tree in a few days.

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
