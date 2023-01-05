"""Add auth failures table

Revision ID: 81e4b17efa47
Revises: 37aeecea6151
Create Date: 2023-01-05 14:22:32.250150

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '81e4b17efa47'
down_revision = '37aeecea6151'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('auth_failures',
    sa.Column('dt', sa.DateTime(), nullable=False),
    sa.Column('ip', sa.String(length=45), nullable=True),
    sa.PrimaryKeyConstraint('dt')
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('auth_failures')
    # ### end Alembic commands ###
