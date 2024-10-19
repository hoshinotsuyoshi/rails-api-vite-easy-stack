import React, { type FC } from 'react'
import { css } from '../../../styled-system/css'
import { useProductsQuery } from '../../generated/graphql'
import type { Product } from '../../generated/graphql'

type ProductListProps = {
  products: Product[]
}

const ProductList: FC<ProductListProps> = ({ products }) => {
  return (
    <div
      className={css({
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
        gap: '16px',
      })}
    >
      {products.map((product) => (
        <div
          key={product.id}
          className={css({
            border: '1px solid #e0e0e0',
            borderRadius: '8px',
            padding: '16px',
            boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
          })}
        >
          <img
            // src={product.imageUrl}
            src="https://img.skin/300x200"
            alt={product.name}
            className={css({
              width: '100%',
              height: 'auto',
              borderRadius: '8px',
            })}
          />
          <h2 className={css({ fontSize: '18px', marginTop: '8px' })}>
            {product.name}
          </h2>
          <p className={css({ color: '#666', fontSize: '14px' })}>
            {product.description}
          </p>
          <p
            className={css({
              fontSize: '16px',
              fontWeight: 'bold',
              marginTop: '8px',
            })}
          >
            ￥{product.unitPrice.toFixed(2)}
          </p>
          <p
            className={css({
              fontSize: '14px',
              color: product.stock > 0 ? 'green' : 'red',
            })}
          >
            {product.stock > 0 ? 'In Stock' : 'Out of Stock'}
          </p>
        </div>
      ))}
    </div>
  )
}

export const Products = () => {
  const { data, loading } = useProductsQuery()
  const products = data?.products?.nodes?.filter((item) => item !== null)

  return (
    <>
      {loading && <div>Loading...</div>}
      {products && <ProductList products={products} />}
    </>
  )
}
