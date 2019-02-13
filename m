From: Guillaume Nault <gnault@redhat.com>
Subject: [PATCH net-next] sock: consistent handling of extreme
 SO_SNDBUF/SO_RCVBUF values
Date: Wed, 13 Feb 2019 04:30:34 +0100
Message-ID: <2cb69b6987b6e23f8b8c1aa8dc524efa6bd53191.1550026643.git.gnault@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: linux-api@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Marcelo Leitner <mleitner@redhat.com>, Paolo Abeni <pabeni@redhat.com>
List-Id: linux-api@vger.kernel.org

SO_SNDBUF and SO_RCVBUF (and their *BUFFORCE version) may overflow or
underflow their input value. This patch aims at providing explicit
handling of these extreme cases, to get a clear behaviour even with
values bigger than INT_MAX / 2 or lower than INT_MIN / 2.

For simplicity, only SO_SNDBUF and SO_SNDBUFFORCE are described here,
but the same explanation and fix apply to SO_RCVBUF and SO_RCVBUFFORCE
(with 'SNDBUF' replaced by 'RCVBUF' and 'wmem_max' by 'rmem_max').

Overflow of positive values
===========================

When handling SO_SNDBUF or SO_SNDBUFFORCE, if 'val' exceeds
INT_MAX / 2, the buffer size is set to its minimum value because
'val * 2' overflows, and max_t() considers that it's smaller than
SOCK_MIN_SNDBUF. For SO_SNDBUF, this can only happen with
net.core.wmem_max > INT_MAX / 2.

SO_SNDBUF and SO_SNDBUFFORCE are actually designed to let users probe
for the maximum buffer size by setting an arbitrary large number that
gets capped to the maximum allowed/possible size. Having the upper
half of the positive integer space to potentially reduce the buffer
size to its minimum value defeats this purpose.

This patch caps the base value to INT_MAX / 2, so that bigger values
don't overflow and keep setting the buffer size to its maximum.

Underflow of negative values
============================

For negative numbers, SO_SNDBUF always considers them bigger than
net.core.wmem_max, which is bounded by [SOCK_MIN_SNDBUF, INT_MAX].
Therefore such values are set to net.core.wmem_max and we're back to
the behaviour of positive integers described above (return maximum
buffer size if wmem_max <= INT_MAX / 2, return SOCK_MIN_SNDBUF
otherwise).

However, SO_SNDBUFFORCE behaves differently. The user value is
directly multiplied by two and compared with SOCK_MIN_SNDBUF. If
'val * 2' doesn't underflow or if it underflows to a value smaller
than SOCK_MIN_SNDBUF then buffer size is set to its minimum value.
Otherwise the buffer size is set to the underflowed value.

This patch treats negative values passed to SO_SNDBUFFORCE as null, to
prevent underflows. Therefore negative values now always set the buffer
size to its minimum value.

Even though SO_SNDBUF behaves inconsistently by setting buffer size to
the maximum value when passed a negative number, no attempt is made to
modify this behaviour. There may exist some programs that rely on using
negative numbers to set the maximum buffer size. Avoiding overflows
because of extreme net.core.wmem_max values is the most we can do here.

Summary of altered behaviours
=============================

val      : user-space value passed to setsockopt()
val_uf   : the underflowed value resulting from doubling val when
           val < INT_MIN / 2
wmem_max : short for net.core.wmem_max
val_cap  : min(val, wmem_max)
min_len  : minimal buffer length (that is, SOCK_MIN_SNDBUF)
max_len  : maximal possible buffer length, regardless of wmem_max (that
           is, INT_MAX - 1)
^^^^     : altered behaviour

SO_SNDBUF:
+-------------------------+-------------+------------+----------------+
|       CONDITION         | OLD RESULT  | NEW RESULT |    COMMENT     |
+-------------------------+-------------+------------+----------------+
| val < 0 &&              |             |            | No overflow,   |
| wmem_max <= INT_MAX/2   | wmem_max*2  | wmem_max*2 | keep original  |
|                         |             |            | behaviour      |
+-------------------------+-------------+------------+----------------+
| val < 0 &&              |             |            | Cap wmem_max   |
| INT_MAX/2 < wmem_max    | min_len     | max_len    | to prevent     |
|                         |             | ^^^^^^^    | overflow       |
+-------------------------+-------------+------------+----------------+
| 0 <= val <= min_len/2   | min_len     | min_len    | Ordinary case  |
+-------------------------+-------------+------------+----------------+
| min_len/2 < val &&      | val_cap*2   | val_cap*2  | Ordinary case  |
| val_cap <= INT_MAX/2    |             |            |                |
+-------------------------+-------------+------------+----------------+
| min_len < val &&        |             |            | Cap val_cap    |
| INT_MAX/2 < val_cap     | min_len     | max_len    | again to       |
| (implies that           |             | ^^^^^^^    | prevent        |
| INT_MAX/2 < wmem_max)   |             |            | overflow       |
+-------------------------+-------------+------------+----------------+

SO_SNDBUFFORCE:
+------------------------------+---------+---------+------------------+
|          CONDITION           | BEFORE  | AFTER   |     COMMENT      |
|                              | PATCH   | PATCH   |                  |
+------------------------------+---------+---------+------------------+
| val < INT_MIN/2 &&           | min_len | min_len | Underflow with   |
| val_uf <= min_len            |         |         | no consequence   |
+------------------------------+---------+---------+------------------+
| val < INT_MIN/2 &&           | val_uf  | min_len | Set val to 0 to  |
| val_uf > min_len             |         | ^^^^^^^ | avoid underflow  |
+------------------------------+---------+---------+------------------+
| INT_MIN/2 <= val < 0         | min_len | min_len | No underflow     |
+------------------------------+---------+---------+------------------+
| 0 <= val <= min_len/2        | min_len | min_len | Ordinary case    |
+------------------------------+---------+---------+------------------+
| min_len/2 < val <= INT_MAX/2 | val*2   | val*2   | Ordinary case    |
+------------------------------+---------+---------+------------------+
| INT_MAX/2 < val              | min_len | max_len | Cap val to       |
|                              |         | ^^^^^^^ | prevent overflow |
+------------------------------+---------+---------+------------------+

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/sock.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6aa2e7e0b4fb..5de90ed35968 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -713,6 +713,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 */
 		val = min_t(u32, val, sysctl_wmem_max);
 set_sndbuf:
+		/* Ensure val * 2 fits into an int, to prevent max_t()
+		 * from treating it as a negative value.
+		 */
+		val = min_t(int, val, INT_MAX / 2);
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);
 		/* Wake up sending tasks if we upped the value. */
@@ -724,6 +728,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EPERM;
 			break;
 		}
+
+		/* No negative values (to prevent underflow, as val will be
+		 * multiplied by 2).
+		 */
+		if (val < 0)
+			val = 0;
 		goto set_sndbuf;
 
 	case SO_RCVBUF:
@@ -734,6 +744,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 */
 		val = min_t(u32, val, sysctl_rmem_max);
 set_rcvbuf:
+		/* Ensure val * 2 fits into an int, to prevent max_t()
+		 * from treating it as a negative value.
+		 */
+		val = min_t(int, val, INT_MAX / 2);
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 		/*
 		 * We double it on the way in to account for
@@ -758,6 +772,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EPERM;
 			break;
 		}
+
+		/* No negative values (to prevent underflow, as val will be
+		 * multiplied by 2).
+		 */
+		if (val < 0)
+			val = 0;
 		goto set_rcvbuf;
 
 	case SO_KEEPALIVE:
-- 
2.20.1
