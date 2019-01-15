From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v4 2/2] selftests/memfd: Add tests for F_SEAL_FUTURE_WRITE
 seal
Date: Mon, 14 Jan 2019 18:39:59 -0700
Message-ID: <f9ffb7f8-1ff8-3bec-ce79-f9322d8715dc@kernel.org>
References: <20190112203816.85534-1-joel@joelfernandes.org>
 <20190112203816.85534-3-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190112203816.85534-3-joel@joelfernandes.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>, linux-kernel@vger.kernel.org
Cc: dancol@google.com, minchan@kernel.org, Jann Horn <jannh@google.com>, John Stultz <john.stultz@linaro.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, Matthew Wilcox <willy@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>, shuah <shuah@kernel.org>
List-Id: linux-api@vger.kernel.org

On 1/12/19 1:38 PM, Joel Fernandes wrote:
> From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> 
> Add tests to verify sealing memfds with the F_SEAL_FUTURE_WRITE works as
> expected.
> 
> Cc: dancol@google.com
> Cc: minchan@kernel.org
> Cc: Jann Horn <jannh@google.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---

Looks good to me. For selftest part of the series:

Reviewed-by: Shuah Khan <shuah@kernel.org>

thanks,
-- Shuah
