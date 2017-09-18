From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Date: Mon, 18 Sep 2017 10:56:51 -0700
Message-ID: <20170918175651.GA7937@infradead.org>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505749947-26360-5-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This seems to miss any explanation and 6 out of 7 patches.

That being said, I really detest adding weird query modes to random
syscalls.  We should expose capabilities through the interface that
was designed for such things: (f)pathconf, as there are a lot more
important parameters we currently fail to expose to userspace to
start with.
