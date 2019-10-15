From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] Add a new flags-accepting interface for anonymous
 inodes
Date: Tue, 15 Oct 2019 01:08:02 -0700
Message-ID: <20191015080802.GA16814@infradead.org>
References: <20191012191602.45649-1-dancol@google.com>
 <20191012191602.45649-2-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191012191602.45649-2-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, nnk@google.com, nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 12:15:56PM -0700, Daniel Colascione wrote:
> Add functions forwarding from the old names to the new ones so we
> don't need to change any callers.

Independent of the usefulness of the interface (I'll let other comment,
but you defintively want to talk to Al Viro), adding a second interface
for only 17 callers total is a bad idea.  Just switch the existing
interface to pass flags.
