From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v4 2/2] selftests/memfd: Add tests for
 F_SEAL_FUTURE_WRITE seal
Date: Tue, 15 Jan 2019 09:50:05 -0500
Message-ID: <20190115145005.GC36681@google.com>
References: <20190112203816.85534-1-joel@joelfernandes.org>
 <20190112203816.85534-3-joel@joelfernandes.org>
 <f9ffb7f8-1ff8-3bec-ce79-f9322d8715dc@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f9ffb7f8-1ff8-3bec-ce79-f9322d8715dc@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, dancol@google.com, minchan@kernel.org, Jann Horn <jannh@google.com>, John Stultz <john.stultz@linaro.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Matthew Wilcox <willy@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 14, 2019 at 06:39:59PM -0700, shuah wrote:
> On 1/12/19 1:38 PM, Joel Fernandes wrote:
> > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > 
> > Add tests to verify sealing memfds with the F_SEAL_FUTURE_WRITE works as
> > expected.
> > 
> > Cc: dancol@google.com
> > Cc: minchan@kernel.org
> > Cc: Jann Horn <jannh@google.com>
> > Cc: John Stultz <john.stultz@linaro.org>
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> 
> Looks good to me. For selftest part of the series:
> 
> Reviewed-by: Shuah Khan <shuah@kernel.org>

Thanks!

John, could you provide your Reviewed-by again for patch 1/2 ? I had dropped
it since the patch had some more changes.

thanks,

 - Joel
