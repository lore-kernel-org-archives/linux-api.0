From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] Add a concept of a "secure" anonymous file
Date: Tue, 15 Oct 2019 01:08:34 -0700
Message-ID: <20191015080834.GB16814@infradead.org>
References: <20191012191602.45649-1-dancol@google.com>
 <20191012191602.45649-3-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191012191602.45649-3-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, nnk@google.com, nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 12:15:57PM -0700, Daniel Colascione wrote:
> A secure anonymous file is one we hooked up to its own inode (as
> opposed to the shared inode we use for non-secure anonymous files). A
> new selinux hook gives security modules a chance to initialize, label,
> and veto the creation of these secure anonymous files. Security
> modules had limit ability to interact with non-secure anonymous files
> due to all of these files sharing a single inode.

Again please add Al.  Also explain what the problem would be to always
use a separate inode.
