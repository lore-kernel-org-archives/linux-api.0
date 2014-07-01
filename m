From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Tue, 1 Jul 2014 01:13:11 -0700
Message-ID: <20140701081311.GA21973@infradead.org>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVMHPdEzai32jRmLt7qGMFcUqFb8OunF0tzySpKoLWWiwQ@mail.gmail.com>
	<CACVXFVMb4UXRYSp6nvjDQrDRcLP6rJ3_3QHYMzKv9MoogsU66w@mail.gmail.com>
	<53B22473.8010709@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <53B22473.8010709@kernel.dk>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 09:01:07PM -0600, Jens Axboe wrote:
> >I appreciate very much that one of you may queue these two
> >patches into your tree so that userspace work can be kicked off,
> >since Michael has acked both patches and all comments have
> >been addressed already.
> 
> Given that Michael also acked it and Rusty is on his sabbatical, I'll queue
> it up for 3.17.

So Rusty is offline?  Who is taking care of module/moduleparam patches
in the meantime?
